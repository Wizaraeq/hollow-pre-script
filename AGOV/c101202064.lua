--Ｃｏｎｃｏｕｒｓ ｄｅ Ｃｕｉｓｉｎｅ～菓冷なる料理対決～
function c101202064.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101202064)
	e1:SetTarget(c101202064.target)
	e1:SetOperation(c101202064.operation)
	c:RegisterEffect(e1)
	--Increase the ATK of a monster by 200 x the number of "Recipe" cards in the GYs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202064,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101202064+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101202064.atktg)
	e2:SetOperation(c101202064.atkop)
	c:RegisterEffect(e2)
end
function c101202064.cfilter(c,archetyp)
	return c:IsSetCard(archetyp) and c:IsType(TYPE_PENDULUM)
end
function c101202064.firstsummon(c,e,tp,sg)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
		and sg:IsExists(c101202064.secondsummon,1,c,e,tp)
end
function c101202064.secondsummon(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		or Duel.GetLocationCountFromEx(1-tp,tp,nil,c)>0)
end
function c101202064.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsSetCard,nil,0x29d)==1
		and sg:FilterCount(Card.IsSetCard,nil,0x196)==1
		and sg:IsExists(c101202064.firstsummon,1,nil,e,tp,sg)
end
function c101202064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c101202064.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,0x196)
	local g2=Duel.GetMatchingGroup(c101202064.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,0x29d)
	local g=g1+g2
	if chk==0 then return #g1>0 and #g2>0 and g:CheckSubGroup(c101202064.rescon,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function c101202064.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c101202064.sumtg)
	e1:SetValue(c101202064.fuslimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(c101202064.sumlimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
	local g1=Duel.GetMatchingGroup(c101202064.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,0x196)
	local g2=Duel.GetMatchingGroup(c101202064.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,0x29d)
	if #g1==0 or #g2==0 then return end
	local g=g1+g2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c101202064.rescon,false,2,2,e,tp)
	if #sg~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101202064,2))
	local ssg=sg:FilterSelect(tp,c101202064.firstsummon,1,1,nil,e,tp,sg)
	if #ssg==0 then return end
	Duel.SpecialSummonStep(ssg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep((sg-ssg):GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
function c101202064.sumtg(e,c)
	return not (c:IsSetCard(0x196) or c:IsSetCard(0x29d))
end
function c101202064.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION
end
function c101202064.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c101202064.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,e:GetHandler(),0x197)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101202064.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,0x197)
	if ct==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end