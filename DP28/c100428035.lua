--ＣＮｏ.７９ ＢＫ 将星のカエサル
function c100428035.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--Gain 200 ATK per each material attached
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100428035.atkval)
	c:RegisterEffect(e1)
	--Negate Special Summons and destroy that monster(s)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100428035,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100428035.negsumcond)
	e2:SetTarget(c100428035.negsumtg)
	e2:SetOperation(c100428035.negsumop)
	c:RegisterEffect(e2)
	--Attach monsters when an attack is declared involving a "Battlin' Boxer" monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100428035,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100428035.atchcond)
	e3:SetTarget(c100428035.atchtg)
	e3:SetOperation(c100428035.atchop)
	c:RegisterEffect(e3)
end
aux.xyz_number[100428035]=79
function c100428035.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c100428035.negsumcond(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-ep and Duel.GetCurrentChain(true)==0
end
function c100428035.negsumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function c100428035.negsumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_EFFECT)==2 then
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c100428035.atchcond(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,71921856) then return false end
	local a,b=Duel.GetBattleMonster(tp)
	return a and b and a:IsFaceup() and a:IsSetCard(0x1084)
end
function c100428035.tgfilter(c)
	return c:IsSetCard(0x1084) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c100428035.atchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local _,b=Duel.GetBattleMonster(tp)
	if chk==0 then return b:IsAbleToChangeControler()
		and Duel.IsExistingMatchingCard(c100428035.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100428035.atchop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100428035.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local _,tc=Duel.GetBattleMonster(tp)
		if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp)
			and not tc:IsImmuneToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
			Duel.Overlay(e:GetHandler(),tc,true)
		end
	end
end