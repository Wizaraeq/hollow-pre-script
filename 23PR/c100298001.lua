--エクストクス・ハイドラ
function c100298001.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c100298001.ffilter,2,99,false)
	--Check materials used for Fusion Summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c100298001.matcheck)
	c:RegisterEffect(e0)
	--Reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c100298001.atkcon)
	e1:SetTarget(c100298001.atktg)
	e1:SetValue(c100298001.atkval)
	c:RegisterEffect(e1)
	--Draw cards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100298001,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c100298001.drcon)
	e2:SetTarget(c100298001.drtg)
	e2:SetOperation(c100298001.drop)
	c:RegisterEffect(e2)
end
function c100298001.ffilter(c,fc)
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_MZONE) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c100298001.matcheck(e,c)
	local mt=c:GetMaterial()
	local typ=0
	if mt:IsExists(Card.IsType,1,nil,TYPE_FUSION) then typ=bit.bor(typ,TYPE_FUSION) end
	if mt:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then typ=bit.bor(typ,TYPE_SYNCHRO) end
	if mt:IsExists(Card.IsType,1,nil,TYPE_XYZ) then typ=bit.bor(typ,TYPE_XYZ) end
	if mt:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) then typ=bit.bor(typ,TYPE_PENDULUM) end
	if mt:IsExists(Card.IsType,1,nil,TYPE_LINK) then typ=bit.bor(typ,TYPE_LINK) end
	c:RegisterFlagEffect(100298001,RESET_EVENT+RESETS_STANDARD&~RESET_TOFIELD,0,1,typ)
end
function c100298001.atkcon(e)
	return e:GetHandler():GetFlagEffect(100298001)>0
end
function c100298001.atktg(e,c)
	return c:IsType(e:GetHandler():GetFlagEffectLabel(100298001))
end
function c100298001.atkval(e,c)
	return -c:GetBaseAttack()
end
function c100298001.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and ev>=1000
end
function c100298001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=ev//1000
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c100298001.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end