--ユベル－Ｄａｓ Ｅｗｉｇ Ｌｉｅｂｅ Ｗäｃｈｔｅｒ
function c101203038.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2a4),c101203038.ffilter,1,63,true)
	--Inflict 500 damage to your opponent for each Fusion Material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101203038,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101203038.damcon)
	e1:SetTarget(c101203038.damtg)
	e1:SetOperation(c101203038.damop)
	c:RegisterEffect(e1)
	--Cannot be destroyed by battle or card effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--You take no battle damage from battles involving this card
	local e4=e2:Clone()
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e4)
	--Inflict damage to your opponent equal to their monster's ATK and banish that monster
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101203038,1))
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c101203038.damrmcon)
	e5:SetTarget(c101203038.damrmtg)
	e5:SetOperation(c101203038.damrmop)
	c:RegisterEffect(e5)
end
function c101203038.ffilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsOnField()
end
function c101203038.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101203038.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if chk==0 then return mg and #mg>0 end
	local dmg=#mg*500
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dmg)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
end
function c101203038.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c101203038.damrmcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if not bc then return false end
	if bc:IsRelateToBattle() then
		return bc:IsControler(1-tp)
	else
		return bc:IsPreviousControler(1-tp)
	end
end
function c101203038.damrmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	local dam=0
	if bc:IsRelateToBattle() then
		dam=bc:GetAttack()
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
	else
		dam=bc:GetPreviousAttackOnField()
		e:SetLabel(dam)
	end
	e:SetLabelObject(bc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c101203038.damrmop(e,tp,eg,ep,ev,re,r,rp)
	local dam=0
	local bc=e:GetLabelObject()
	local battle_relation=bc:IsRelateToBattle()
	if battle_relation and bc:IsFaceup() and bc:IsControler(1-tp) then
		dam=bc:GetAttack()
	elseif not battle_relation then
		dam=e:GetLabel()
	end
	if Duel.Damage(1-tp,dam,REASON_EFFECT)>0 and battle_relation then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end